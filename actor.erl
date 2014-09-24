-module(actor).
-include("actor.hrl").

-export([create/0
        ,move/2
        ,take/2
        ,say/2]).

create() ->
    #actor{}.

move(Actor, Dir) ->
    Actor ! {move, Dir}.

take(Actor, Thing) ->
    Actor ! {take, Thing}.

say(Actor, Chat) ->
    Actor ! {say, Chat}.

