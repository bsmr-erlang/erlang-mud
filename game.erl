-module(game).
-include("game.hrl").
-include("room.hrl").

-export([create/0,
         create/1,
         create/2,
         add_room/2,
         add_actor/2]).

create() ->
    create(default_rooms()).
create(Rooms) ->
    create(Rooms, default_ai()).
create(Rooms, Actors) ->
    #state{rooms=Rooms, actors=Actors}.

default_rooms() ->
    [#room{}].

default_ai() -> [].

add_actor(State, Actor) ->
    State#state{actors=[Actor|State#state.actors]}.

add_room(State, Room) ->
    RoomPid = room_proc:start(Room),
    State#state{rooms=[RoomPid|State#state.rooms]}.
