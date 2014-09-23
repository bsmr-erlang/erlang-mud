-module(server).
-include("room.hrl").
-include("game.hrl").
-export([start/1,
         stop/1
        ]).

start(Game) ->
    spawn(fun() ->
                  server(Game)
          end).

stop(Server) ->
    Server ! terminate.

server(State) ->
    Timeout = State#state.timeout,
    receive
        {add_actor, Actor} ->
            server(add_actor(State, Actor));
        {add_room, Room} ->
            server(add_room(State, Room));
        terminate ->
            State;
        heartbeat -> server(State)
    after Timeout ->
        server(State)
    end.

add_actor(Game, Actor) ->
    NewGame = game:add_actor(Game, Actor),
    update_actors(NewGame, Actor#actor.room),
    NewGame.
    lists:map(fun({Pid, _}) -> Pid ! {add

