-module(server).
-include("room.hrl").
-export([start/0,
         start/1,
         start/2,
         stop/1,
         add_actor/2,
         add_room/2
        ]).

start() ->
    start(default_rooms()).
start(Rooms) ->
    start(Rooms, default_ai()).
start(Rooms, Actors) ->
    spawn(fun() ->
                  server(Rooms, Actors)
          end).

stop(Server) ->
    Server ! terminate.

-record(state, {timeout=10,
               actors=[],
               rooms=[]}).

server(Rooms, Actors) ->
    server(#state{rooms=Rooms, actors=Actors}).

server(State) ->
    Timeout = State#state.timeout,
    receive
        {add_room, Room} ->
            server(add_room(State, Room));
        terminate ->
            State;
        heartbeat -> server(State)
    after Timeout ->
        server(State)
    end.

default_rooms() ->
    [#room{}].

default_ai() -> [].

add_actor(State, Actor) ->
    State#state{actors=[Actor|State#state.actors]}.

add_room(State, Room) ->
    State#state{rooms=[Room|State#state.rooms]}.

