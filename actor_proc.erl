-module(actor_proc).

-include("actor.hrl").

-export([start/1
        ,move/2
        ,take/2
        ,say/2]).

-spec(start(#actor{}) -> pid()).
start(Actor) ->
    spawn(fun() -> actor(Actor, self()) end).

actor(Actor, Console) ->
    receive
        {command, Source, Command} ->
            actor(Actor, Console);
        {say, _} ->
            
            actor(Actor, Console);
        
        terminate ->
            Actor#actor.room ! {move_actor_to, self()}
    end.

-spec(move(pid(), atom()) -> any()).
move(Actor, Dir) ->
    Actor ! {move_actor, Dir}.

take(Actor, Thing) ->
    Actor ! {take, Thing}.

say(Actor, Chat) ->
    Actor ! {say, Chat}.

