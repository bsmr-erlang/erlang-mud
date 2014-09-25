-module(server).
-include("room.hrl").
-include("game.hrl").
-include("actor.hrl").
-export([start/0,
         start/1,
         stop/1
        ]).

start() -> start(new_game()).
start(Game) ->
    spawn(fun() ->
                  server(Game)
          end).

new_game() -> #state{}.

stop(Server) ->
    Server ! terminate.

server(Game) ->
    Timeout = Game#state.timeout,
    receive
        {add_actor, Actor} ->
            server(add_actor(Game, Actor));
        {add_room, Room} ->
            server(add_room(Game, Room));
        terminate ->
            Game;
        heartbeat -> server(Game)
    after Timeout ->
        server(Game)
    end.

add_room(Game, Room) ->
    RoomPid = room_proc:start(Room),
    game:add_room(Game, RoomPid).

add_actor(Game, Actor) ->
    NewGame = game:add_actor(Game, Actor),
    update_actors(Actor#actor.room),
    NewGame.

update_actors(Room) ->
    Room ! {update_actors}.
              

