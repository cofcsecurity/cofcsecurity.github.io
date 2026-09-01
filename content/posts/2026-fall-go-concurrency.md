---
title: Go Concurrency and Bounded Concurrency Patterns
date: 2026-09-01
---

*This guide aggregates examples and content from various sources. Not all wording and code is original.*

## Introduction

This guide provides a foundation for implementing common concurrency patterns, including bounded concurrency, in Go. Bounded concurrency is a pattern of setting structural limits on concurrent operations, protecting finite resources like memory and compute.

Although the focus of this doc is bounded concurrency, executing this pattern requires an understanding of Go's concurrency model. To ensure a shared vocab, the first half of this guide provides a basic explanation of Go's concurrency mechanisms: goroutines, channels, buffers, and context. If you're already familiar with how these operate, you can skip to the bounded concurrency notes.

## Concepts

### Goroutines

A `goroutine` is a lightweight thread managed by the Go runtime, rather than the operating system. That is, it isn't a fully fledged OS thread. When you invoke a function with the `go` keyword, the runtime starts a thread with a dynamic stack that grows and shrinks as needed. Goroutines are very cheap; you can run tens of thousands concurrently.

* [A Tour of Go: Goroutines](https://go.dev/tour/concurrency/1)
* [Concurrency in Go: Goroutines and Channels Explained with Real Examples](https://dev.to/oketch/concurrency-in-go-goroutines-and-channels-explained-with-real-examples-19j0)

### Goroutine Leaks

A `goroutine leak` occurs when a goroutine is spawned but never exits. Because the Go runtime has no way to garbage collect a running goroutine, leaked goroutines accumulate for the lifetime of the process, consuming memory and any resources they hold open.

The most common cause is a goroutine blocked on a channel receive that never gets a value:

```go
func doWork(ch <-chan Job) {
    go func() {
        job := <-ch // blocks forever if nothing sends on ch and it is never closed
        process(job)
    }()
}
```

If the caller discards `ch` without closing it or sending a value, the goroutine hangs. With enough calls to `doWork`, the process accumulates many stuck goroutines.

The fix is to always give goroutines an exit path via a `context` cancellation signal checked with `select`:

```go
func doWork(ctx context.Context, ch <-chan Job) {
    go func() {
        select {
        case job := <-ch:
            process(job)
        case <-ctx.Done(): // guaranteed exit when context is cancelled
            return
        }
    }()
}
```

Note: this is one of the core reasons `context.Context` is passed through concurrent Go code. It is not just for timeouts; it is the mechanism that guarantees goroutines have a way out. The `defer wg.Done()` pattern in worker pools serves the same purpose from the caller's side, ensuring `wg.Wait()` is never stuck on a goroutine that exited early.

Leaks can be detected at test time using the `goleak` library, which asserts that no unexpected goroutines are running at the end of a test.

* [Uber Go: goleak — Goroutine Leak Detector](https://github.com/uber-go/goleak)
* [Dave Cheney: Never start a goroutine without knowing how it will stop](https://dave.cheney.net/2016/12/22/never-start-a-goroutine-without-knowing-how-it-will-stop)

### Channels

A `channel` is a pipe that connects concurrent goroutines. They provide a way to send and receive values between goroutines. Passing data through a channel shifts ownership of that data from one goroutine to another, preventing race conditions. This is Go's alternative to coordinating shared memory with a `sync.Mutex`; channels communicate by sharing data, not sharing data to communicate.

A `sync.Mutex` (mutual exclusion lock) is the lower-level alternative. It protects a shared variable by allowing only one goroutine to hold the lock at a time. Any goroutine that tries to lock a held mutex blocks until the current holder calls `Unlock`.

```go
var mu sync.Mutex
var counter int
mu.Lock()
counter++ // only one goroutine can be here at a time
mu.Unlock()
```

Mutexes are appropriate when multiple goroutines need to read and write a shared data structure in place. Channels are preferred when goroutines are passing data between one another, as the transfer of ownership is explicit and more readable. In practice, most Go codebases use both, choosing whichever fits the coordination pattern more naturally.

* [A Tour of Go: Channels](https://go.dev/tour/concurrency/2)
* [Go by Example: Mutexes](https://gobyexample.com/mutexes)
* [Go Dev Blog: Share Memory by Communicating](https://go.dev/blog/codelab-share)

### Unbuffered Channels

An `unbuffered` channel is a synchronous pipe with zero internal storage capacity. A sender attempting to push data into the channel will block until a receiver is ready to take it, and vice versa. That is, a direct handoff. Unbuffered channels are useful for synchronization, as you can guarantee that a piece of work has been picked up before moving on.

Analogy: a relay race baton pass. The outgoing runner cannot let go until the incoming runner has a firm grip. Neither can move on until the exchange is complete.

* [Go by Example: Channel Synchronization](https://gobyexample.com/channel-synchronization)

### Buffered Channels

A `buffered` channel introduces asynchronous capability by including a fixed-capacity storage shelf inside the pipe. You initialize it with a predefined capacity: `make(chan int, 5)`. Senders can push data and immediately move on without blocking, provided the buffer isn't full. Receivers pull items at their own pace, only blocking if the buffer is entirely empty. This decouples the timing between producers and consumers, and makes buffered channels well suited for absorbing bursts of work.

Analogy: a physical inbox tray on a desk. A colleague can drop off a document and walk away without waiting for you to read it. You process the tray at your own pace. If the tray fills up, the next person dropping something off has to wait until there's room.

* [A Tour of Go: Buffered Channels](https://go.dev/tour/concurrency/3)

### Context

The `context` package manages lifecycle, cancellation signals, and deadlines across cascading chains of goroutines. A `Context` is passed as the first argument to every child function or background worker in a pipeline. If an upstream client cancels a request or a timeout is hit, the context channel closes (`<-ctx.Done()`), broadcasting a signal to all active child goroutines to stop and clean up, preventing rogue, orphaned routines.

* [Go Dev Blog: Go Concurrency Patterns: Context](https://go.dev/blog/context)
* [context package](https://pkg.go.dev/context)

## Syntax Reference

Go concurrency patterns use a handful of Go-specific constructs that might be unfamiliar coming from other languages. This section briefly explains each one.

### The `<-` Operator

`<-` is the channel operator. Its direction relative to the channel name determines whether you are sending or receiving.

```go
ch <- value   // send: push value into ch; blocks if ch is full
value := <-ch // receive: pull a value out of ch; blocks if ch is empty
<-ch          // receive and discard: unblocks when ch has a value, ignores it
```

The direction of the arrow reflects the direction of data flow. `ch <- value` pushes data into the channel (arrow points in). `<-ch` pulls data out (arrow points out, away from the channel name).

When used on a `context.Done()` channel, `<-ctx.Done()` receives from the done channel. Since `ctx.Done()` returns a channel that is only closed (never written to), this receive unblocks the moment the context is cancelled or times out. It is the standard idiom for listening for a shutdown signal.

### `make(chan T, n)`

`make` is Go's built-in function for initializing channels, slices, and maps. For channels:

```go
ch := make(chan int)     // unbuffered: zero capacity, synchronous handoff
ch := make(chan int, 5)  // buffered: capacity 5, can hold 5 values before blocking
```

The second argument is the buffer capacity. Omitting it creates an unbuffered channel, as the default capacity is 0.

`chan struct{}` is a common idiom for channels used only as signals rather than data carriers. `struct{}` is an empty struct that occupies zero bytes, so it carries no information. Only the act of sending or receiving it matters.

### `select`

`select` is like a `switch` statement for channel operations. It blocks until one of its cases can proceed, then executes that case. If multiple cases are ready simultaneously, Go picks one at random.

```go
select {
case job := <-jobs:     // fires when jobs has a value to receive
    handle(job)
case <-ctx.Done():      // fires when the context is cancelled
    return
}
```

The `default` case makes a `select` non-blocking: if no other case is ready, `default` runs immediately instead of blocking.

```go
select {
case job := <-jobs:
    handle(job)
default:
    // nothing ready, move on immediately
}
```

`select` is for waiting on multiple channels at once without committing to any single one.

### `for range` on a Channel

`for job := range ch` reads from a channel in a loop, blocking between iterations until the next value arrives. It exits automatically when the channel is closed and drained.

```go
for job := range work {
    process(job) // blocks here until work has a value or is closed
}
```

This is the pattern for a worker goroutine consuming from a job channel. The producer signals completion by calling `close(work)`, which causes the loop to exit after processing any remaining buffered values.

### `close`

`close(ch)` closes a channel. After closing, no more values can be sent; attempts to send will panic. Receivers can still drain any buffered values, and further receives on an empty closed channel return the zero value immediately rather than blocking.

Closing is a broadcast signal: all goroutines ranging over or selecting on a closed channel will unblock. This is how a producer signals "no more work" to a pool of workers.

### `defer`

`defer` schedules a function call to run when the surrounding function returns, regardless of how it returns (normal exit, early return, or panic).

```go
defer wg.Done()           // called when the goroutine function exits
defer func() { <-sem }()  // anonymous function deferred: releases semaphore token on exit
```

In concurrency code, `defer` is used to guarantee cleanup, releasing a semaphore token, decrementing a WaitGroup counter, or closing a resource, even if the function returns early due to an error.

### `sync.WaitGroup`

A `WaitGroup` is a counter for tracking a set of goroutines. The caller increments it before spawning each goroutine and waits for it to reach zero.

```go
var wg sync.WaitGroup
wg.Add(1)       // increment before spawning
go func() {
    defer wg.Done() // decrement when goroutine exits
    doWork()
}()
wg.Wait()       // blocks until counter reaches zero
```

Caution: `wg.Add(1)` must be called before the goroutine starts, not inside it. If the goroutine starts and calls `wg.Done()` before the parent calls `wg.Add(1)`, the counter can transiently hit zero and `wg.Wait()` can return prematurely.

* [sync package: WaitGroup](https://pkg.go.dev/sync#WaitGroup)
* [Go by Example: WaitGroups](https://gobyexample.com/waitgroups)

### `context.WithTimeout` and `context.WithCancel`

`context.WithCancel(parent)` returns a derived context and a `cancel` function. Calling `cancel()` closes the derived context's `Done` channel, signalling all goroutines holding that context to stop.

```go
ctx, cancel := context.WithCancel(context.Background())
defer cancel() // always call cancel to release resources
go func() {
    select {
    case <-ctx.Done(): // unblocks when cancel() is called
        return
    case job := <-jobs:
        handle(job)
    }
}()
```

`context.WithTimeout(parent, duration)` does the same but also cancels automatically after the given duration elapses. It returns both a derived context and a cancel function; the cancel function should still be called explicitly via `defer` to release resources if the work finishes before the timeout.

```go
ctx, cancel := context.WithTimeout(parentCtx, 5*time.Second)
defer cancel()
conn, err := dialer.DialContext(ctx, "tcp", addr) // fails if 5s elapses
```

### `go func()(...)()`

Anonymous goroutines follow a common pattern:

```go
go func(j Job) {
    process(j)
}(job)
```

`func(j Job) { ... }` declares an anonymous function with parameter `j`. The trailing `(job)` immediately calls it, passing the current value of `job` as the argument. The leading `go` runs that call in a new goroutine.

Caution: passing `job` as an explicit argument rather than closing over it is important in loops. A closure that captures the loop variable directly will see whatever value that variable holds when the goroutine actually runs, not when it was spawned. This is a common source of bugs in concurrent Go code.

## Example

The pattern below demonstrates a basic concurrent fan-out. A fixed set of worker goroutines pull jobs from a shared channel, with a context wiring in cancellation. Bounded concurrency builds on this pattern.

```go
func runWorkers(ctx context.Context, jobs <-chan Job, n int) {
    var wg sync.WaitGroup
    for i := 0; i < n; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            for {
                select {
                case job, ok := <-jobs:
                    if !ok {
                        return // channel closed, no more work
                    }
                    handle(job)
                case <-ctx.Done():
                    return // upstream cancelled
                }
            }
        }()
    }
    wg.Wait()
}
```

Note:

* Workers are pre-spawned to `n`; the number of concurrent goroutines is fixed at startup, not per job.
* `select` on `ctx.Done()` lets the runtime signal all workers to exit without leaking goroutines.
* `sync.WaitGroup` ensures the caller blocks until all workers have finished before proceeding.

This example is unbounded in terms of how many jobs can queue up, but the number of goroutines doing work at any moment is capped at `n`.

## Error Propagation from Goroutines

A goroutine cannot return a value to its caller the way a normal function can. Once spawned, it runs independently, so any errors it encounters need to be communicated back through a channel.

The pattern is an error channel, typically sized to the number of goroutines so senders never block:

```go
errs := make(chan error, n)
for i := 0; i < n; i++ {
    go func(i int) {
        if err := doWork(i); err != nil {
            errs <- err
        }
    }(i)
}
// Collect results after all goroutines finish
// (use a WaitGroup to know when to stop reading)
wg.Wait()
close(errs)
for err := range errs {
    log.Println("worker error:", err)
}
```

Caution: if the error channel is unbuffered and no one is reading from it, a goroutine that tries to send will block indefinitely, causing a goroutine leak. Buffering to `n` ensures every goroutine can send at most one error without blocking.

Note: this pattern collects all errors after the fact. If you need to cancel remaining work on the first error, combine the error channel with a context cancellation:

```go
ctx, cancel := context.WithCancel(context.Background())
errs := make(chan error, n)
for i := 0; i < n; i++ {
    wg.Add(1)
    go func(i int) {
        defer wg.Done()
        if err := doWork(ctx, i); err != nil {
            errs <- err
            cancel() // signal other goroutines to stop
        }
    }(i)
}
wg.Wait()
cancel() // always call cancel to release context resources
close(errs)
```

Note: calling `cancel()` after `wg.Wait()` is required even if no error occurred, to release the resources held by the context. Using `defer cancel()` immediately after creating the context is the idiomatic way to ensure this.

For more complex pipelines where you want the first error and automatic cancellation of all workers, the `golang.org/x/sync/errgroup` package provides this pattern out of the box.

* [errgroup package](https://pkg.go.dev/golang.org/x/sync/errgroup)
* [Go Dev Blog: Error handling and Go](https://go.dev/blog/error-handling-and-go)
* [Go by Example: Goroutines](https://gobyexample.com/goroutines)

## Bounded Concurrency

Bounded concurrency is the practice of setting a limit on how many goroutines can perform work simultaneously, preventing infrastructure overload.

While the Go runtime makes it trivial to spin up 50,000 goroutines, doing so can quickly exhaust database connection pools, hit API rate limits, or overwhelm network I/O. There are two common patterns for enforcing this limit:

### Pattern 1: Semaphore via Buffered Channel

A buffered channel of capacity `K` acts as a token pool. Each goroutine must acquire a token before doing work and release it on completion. If all `K` tokens are held, new goroutines block until one is returned.

Analogy: a coat check with `K` numbered tickets. Anyone who wants to do work must first claim a ticket. If all tickets are out, they wait by the desk until someone returns one.

```go
sem := make(chan struct{}, K) // K = max concurrent workers
for _, job := range jobs {
    sem <- struct{}{} // acquire token; blocks if K workers are already active
    go func(j Job) {
        defer func() { <-sem }() // release token on completion
        process(j)
    }(job)
}
```

This pattern is simple and works well for short-lived bursts where you want to cap concurrency without pre-allocating goroutines. The tradeoff is that it still spawns a new goroutine per job; it just throttles how many run simultaneously.

### Pattern 2: Fixed Worker Pool

A fixed set of `K` goroutines is pre-spawned at startup. They block-read from a shared job channel and process work as it arrives. When all workers are busy, sends on the job channel block, throttling the producer.

Analogy: a team of `K` cashiers at a grocery store. The cashiers are always present, waiting for the next customer in line. If all registers are occupied, new customers queue up. No new cashier is hired per customer; the same staff handles everything throughout the day.

```go
work := make(chan Job, bufferSize)
var wg sync.WaitGroup
for i := 0; i < K; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        for job := range work {
            process(job)
        }
    }()
}
// Dispatch jobs
for _, j := range jobs {
    work <- j
}
close(work) // signals workers to exit after draining
wg.Wait()
```

This pattern is better suited to long-running systems where workers should be persistent. Ex: a background service continuously polling a queue. Goroutine overhead is paid once at startup rather than per job, and the pool size directly controls peak resource consumption.

Note: the channel buffer size and the worker count are independent. Setting them equal is a common default, but it is not a requirement. The worker count bounds concurrency; the buffer size bounds how much work can queue up in memory ahead of the workers. The next section covers how to use this distinction intentionally.

Which to use: prefer the semaphore pattern for short batch operations with a known input set; prefer the worker pool for continuous, server-style workloads where the job stream is open-ended.

* [Go Web Examples: Worker Pools](https://gowebexamples.com/worker-pools/)
* [Why Your Goroutines Need a Speed Limit: Bounded Concurrency in Go](https://lorbic.com/bounded-concurrency-in-go/)
* [Go by Example: Worker Pools](https://gobyexample.com/worker-pools)

## Tuning the Channel Buffer Size

In the worker pool pattern, the channel buffer size and the worker count are independent knobs and do not have to match. The worker count controls how many jobs run concurrently; the buffer size controls how many jobs can sit queued in memory before the producer blocks.

Setting the buffer larger than `K` lets the producer pre-load a batch into the channel without waiting for workers to finish their current jobs. Workers can then pick up the next item immediately after completing one, rather than idling while the producer fetches more work. This is useful when fetching jobs has latency of its own, such as a Postgres poll or a network call.

```go
const workers = 8
const buffer = 32 // pre-fetch up to 32 jobs ahead of workers
work := make(chan Job, buffer)
for i := 0; i < workers; i++ {
    go func() {
        for job := range work {
            process(job)
        }
    }()
}
```

The tradeoff is that jobs in the channel have been claimed from the upstream source but not yet processed. If the process crashes, those jobs are in-flight but unfinished. Whether that matters depends on whether your upstream source can recover them. Consider Postgres: a crash rolls back the `SELECT ... FOR UPDATE` transaction and makes the rows visible again, so a larger buffer is safe. With a destructive dequeue (delete on read), jobs in the buffer at crash time are lost.

A reasonable default is to set the buffer to a small multiple of the worker count, such as 2x or 4x, to keep workers fed without holding too much in memory at once.

* [Go Web Examples: Worker Pools](https://gowebexamples.com/worker-pools/)
* [Why Your Goroutines Need a Speed Limit: Bounded Concurrency in Go](https://lorbic.com/bounded-concurrency-in-go/)

## Use Cases

### Concurrent Web Scraping

Fetching a large list of URLs is a common case for bounded concurrency. Issuing one goroutine per URL for a list of thousands will open far more simultaneous HTTP connections than a well-behaved client (or the remote server) can tolerate, and a slow or unresponsive host can tie up a goroutine indefinitely if there's no timeout.

The semaphore pattern is a natural fit: each goroutine acquires a token before making a request and releases it when done, capping how many requests are in flight at once. A `context.WithTimeout` around each request ensures a single hung connection doesn't stall the batch, and results are collected on a channel rather than written directly from each goroutine, since a slice or map is not safe for concurrent writes.

```go
type Result struct {
    URL  string
    Body []byte
    Err  error
}

func fetchAll(ctx context.Context, urls []string, k int) []Result {
    sem := make(chan struct{}, k) // cap concurrent in-flight requests
    results := make(chan Result, len(urls))
    var wg sync.WaitGroup
    for _, u := range urls {
        wg.Add(1)
        sem <- struct{}{} // acquire token; blocks if k requests are already active
        go func(url string) {
            defer wg.Done()
            defer func() { <-sem }() // release token on completion
            reqCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
            defer cancel()
            body, err := fetch(reqCtx, url)
            results <- Result{URL: url, Body: body, Err: err}
        }(u)
    }
    wg.Wait()
    close(results)
    out := make([]Result, 0, len(urls))
    for r := range results {
        out = append(out, r)
    }
    return out
}
```

The concurrency cap `k` should generally stay well under the operating system's open file descriptor limit and any per-host connection limits set on the `http.Client`'s transport. A common starting point is somewhere between 10 and 50, tuned based on the target hosts' tolerance and your own network bandwidth.

### Database Connection Pooling

Most database drivers maintain a finite pool of open connections. Each connection consumes memory on both the client and the server, and databases often enforce hard caps on concurrent connections. Spinning up goroutines without a bound means you can hit those caps under load, causing new queries to fail or block unpredictably.

Bounded concurrency maps cleanly onto connection pool limits: set your worker count to at most the size of the connection pool, and each worker can safely assume a connection is available when it needs one. This turns a runtime failure mode into a structural guarantee.

```go
db, _ := sql.Open("postgres", connStr)
db.SetMaxOpenConns(K) // cap the pool at K connections
work := make(chan Query, bufferSize)
for i := 0; i < K; i++ {
    go func() {
        for q := range work {
            rows, err := db.QueryContext(q.ctx, q.sql, q.args...)
            // handle rows, err
        }
    }()
}
```

With `SetMaxOpenConns(K)` and a worker pool of size `K`, the pool and the concurrency limit stay in sync. A common mistake is bounding the worker pool but leaving `MaxOpenConns` unlimited, or vice versa; both levers need to agree for the guarantee to hold.

### Rate Limiting / API Throttling

External APIs typically enforce rate limits: requests per second, per minute, or per token bucket. Unbounded goroutines will saturate those limits immediately under any meaningful load, resulting in 429 errors and retry storms that make throughput worse, not better.

The semaphore pattern works well here, often combined with a `time.Ticker` to enforce a steady request rate rather than just a concurrency cap.

```go
sem := make(chan struct{}, K)        // cap concurrent in-flight requests
ticker := time.NewTicker(rate)      // e.g. time.Second / requestsPerSecond
defer ticker.Stop()
for _, req := range requests {
    <-ticker.C                      // pace requests to the rate limit
    sem <- struct{}{}               // cap concurrent in-flight requests
    go func(r Request) {
        defer func() { <-sem }()
        call(r)
    }(req)
}
```

Analogy: a tollbooth with `K` lanes and a traffic light controlling how often a car is allowed to approach. The light enforces the rate; the lane count enforces concurrency. Both limits protect the downstream system independently.

### File / Image Processing Pipelines

Processing large batches of files, transcoding images, or running OCR are CPU and I/O intensive. Spawning one goroutine per file in a batch of thousands will thrash the CPU scheduler, exhaust memory, and overwhelm disk I/O. The worker pool pattern is a natural fit: a fixed pool processes files from a queue, keeping system load predictable.

```go
paths := make(chan string, len(files))
for _, f := range files {
    paths <- f
}
close(paths)

var wg sync.WaitGroup
for i := 0; i < K; i++ {
    wg.Add(1)
    go func() {
        defer wg.Done()
        for path := range paths {
            processFile(path)
        }
    }()
}
wg.Wait()
```

Analogy: a photo development lab with `K` darkroom stations. Film rolls queue up at the counter. Each station picks up the next roll when it finishes the current one. Adding more rolls to the queue does not open more stations; the lab capacity is fixed.

A useful heuristic for sizing `K`: start at `runtime.NumCPU()` for CPU-bound work. For I/O-bound work like network fetches or disk reads, you can go higher since goroutines spend most of their time waiting rather than computing.

## Resources

### Official Go Documentation

* [A Tour of Go: Concurrency](https://go.dev/tour/concurrency/1)
* [Go Dev Blog: Go Concurrency Patterns: Context](https://go.dev/blog/context)
* [Go Dev Blog: Share Memory by Communicating](https://go.dev/blog/codelab-share)
* [sync package](https://pkg.go.dev/sync)
* [context package](https://pkg.go.dev/context)
* [errgroup package](https://pkg.go.dev/golang.org/x/sync/errgroup)

### Guides and Examples

* [Go by Example: Channel Synchronization](https://gobyexample.com/channel-synchronization)
* [Go by Example: Worker Pools](https://gobyexample.com/worker-pools)
* [Go by Example: Mutexes](https://gobyexample.com/mutexes)
* [Go Web Examples: Worker Pools](https://gowebexamples.com/worker-pools/)
* [Concurrency in Go: Goroutines and Channels Explained with Real Examples](https://dev.to/oketch/concurrency-in-go-goroutines-and-channels-explained-with-real-examples-19j0)
* [Why Your Goroutines Need a Speed Limit: Bounded Concurrency in Go](https://lorbic.com/bounded-concurrency-in-go/)
* [goleak: goroutine leak detector for Go tests](https://github.com/uber-go/goleak)

### Further Reading

* Concurrency in Go by Katherine Cox-Buday: the canonical book on Go's concurrency model, covering pipelines, cancellation, and real-world patterns in depth.
* [The Go Memory Model](https://go.dev/ref/mem): defines the happens-before guarantees that underpin safe concurrent access in Go.

[@tlmcguire](https://github.com/tlmcguire)
