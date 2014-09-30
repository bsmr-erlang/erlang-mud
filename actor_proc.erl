-module(actor_proc).

-include("actor.hrl").

-export([start/1
        ,move/2
        ,take/2
        ,say/2]).

start(Actor) ->
    spawn(fun() -> actor(Actor, self()) end).

actor(Actor, Console) ->
    receive
        {in_room, Room} ->
            Console ! {in_room, Room},
            actor(actor:move(Actor, Room), Console);
        {say, _} ->
            actor(Actor, Console)
    end.

move(Actor, Dir) ->
    Actor ! {move, Dir}.

take(Actor, Thing) ->
    Actor ! {take, Thing}.

say(Actor, Chat) ->
    Actor ! {say, Chat}.

