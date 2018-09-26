-module(test).

-export([run/0, run/3, run/4]).

run() ->
    run(1000, 500, 10).

run(Time, Sleep, Jitter) ->
    io:format("Running Lamport time-stamp test:~n"),
    run(Time, Sleep, Jitter, time),
    timer:sleep(1000),
    io:format("~n~nRunning Vector time-stamp test:~n"),
    run(Time, Sleep, Jitter, mvect).

run(Time, Sleep, Jitter, TimeModule) ->
    io:format("Running test for ~w seconds:~n", [Time / 1000]),
    Log = log:start([john, paul, ringo, george], TimeModule),
    A = worker:start(john, Log, 13, Sleep, Jitter, TimeModule),
    B = worker:start(paul, Log, 23, Sleep, Jitter, TimeModule),
    C = worker:start(ringo, Log, 36, Sleep, Jitter, TimeModule),
    D = worker:start(george, Log, 49, Sleep, Jitter, TimeModule),
    worker:peers(A, [B, C, D]),
    worker:peers(B, [A, C, D]),
    worker:peers(C, [A, B, D]),
    worker:peers(D, [A, B, C]),
    timer:sleep(Time),
    io:format("Stopping test~n"),
    worker:stop(A),
    worker:stop(B),
    worker:stop(C),
    worker:stop(D),
    log:stop(Log).