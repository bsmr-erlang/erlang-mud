-module(actor_proc).

-include("actor.hrl").

-export([start/1
        ,move/2
        ,take/2
        ,say/2]).

start(Actor) ->
    spawn(fun() -> actor(Actor) end).

actor(Actor) ->
    receive
        {in_room, Room} ->
            actor(actor:move(Actor, Room));
        {say, _} ->
            actor(Actor)
    end.

move(Actor, Dir) ->
    Actor ! {move, Dir}.

take(Actor, Thing) ->
    Actor ! {take, Thing}.

say(Actor, Chat) ->
    Actor ! {say, Chat}.

