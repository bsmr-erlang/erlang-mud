-module(actor).
-include("actor.hrl").

-export([create/0,
         create/1,
         move/2,
         take/2,
         say/2]).

create() ->
    #actor{}.
create(Name) ->
    #actor{name=Name}.

move(Actor, Dir) ->
    Actor ! {move, Dir}.

take(Actor, Thing) ->
    Actor ! {take, Thing}.

say(Actor, Chat) ->
    Actor ! {say, Chat}.

