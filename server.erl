-module(server).
-include("room.hrl").
-include("game.hrl").
-include("actor.hrl").
-export([start/0,
         start/1,
         stop/1,
         add_room/2,
         add_actor/2
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
            server(game:add_actor(Game, Actor));
        {add_room, Room} ->
            server(game:add_room(Game, Room));
        terminate ->
            Game;
        {command, Actor, Command} ->
            actor_command(Actor, Command);
        heartbeat -> server(Game)
    after Timeout ->
        server(Game)
    end.

add_room(Game, Room) ->
    RoomPid = room_proc:start(Room),
    Game ! {add_room, RoomPid}.

add_actor(Game, Actor) ->
    Game ! {add_actor, Actor},
    % NewGame = game:add_actor(Game, Actor),
    % update_actors(Actor#actor.room),
    Game.

actor_command(Actor, Command) ->
    case Command of
        quit ->
            player_quit(Actor);
        {move, Dir} ->
            player_move(Actor, Dir);
        noop -> ok
    end.

player_quit(ActorPid) ->
    ActorPid ! terminate,
    ok.

-spec(player_move(pid(), atom()) -> any()).
player_move(Actor, Dir) ->
    actor_proc:move(Actor, Dir).


