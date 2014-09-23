-module(actor).
-include("actor.hrl").

-export([create/0
        ,move/2
        ,take/2
        ,say/2]).

create() ->
    #actor{}.

command(Actor, Command) ->
    Actor ! {command, Command}.

