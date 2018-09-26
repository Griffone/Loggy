-module(lvect).

-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).

zero() -> [].

inc(Name, Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, X} ->
            lists:keyreplace(Name, 1, Time, {Name, X + 1});
        false ->
            [{Name, 1} | Time]
    end.

merge([], Time) -> Time;
merge(Time, []) -> Time;
merge([{Name, T1} | Rest], Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, T2} ->
            [{Name, max(T1, T2)} | merge(Rest, lists:keydelete(Name, 1, Time))];
        false ->
            [{Name, T1} | merge(Rest, Time)]
    end.

leq([], _) -> true;
leq([{Name, T1} | Rest], Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, T2} ->
            if
                T1 =< T2 ->
                    leq(Rest, Time);
                true ->
                    false
            end;
        false ->
            % Hack, as we know that T1 should always be >0 in our implementation
            false
    end.

clock(_) -> [].

update(From, Time, Clock) ->
    TElement = lists:keyfind(From, 1, Time),
    case lists:keyfind(From, 1, Clock) of
        {From, _} ->
            lists:keyreplace(From, 1, Clock, TElement);
        false ->
            [TElement | Clock]
    end.

safe(Time, Clock) -> leq(Time, Clock).