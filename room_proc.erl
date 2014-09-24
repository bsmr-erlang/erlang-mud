-module(room_proc).
-include("room.hrl").
-include("item.hrl").
-include("actor.hrl").
-export([start/1,
        update_actors/1]).

start(Room) ->
    Fun = fun() -> room(Room) end,
    spawn_link(Fun).

room(Room) ->
    update_actors(Room),
    receive
        {add_item, Item}
          when is_record(Item, item)
               -> room(room:add(Room, Item));
        {add_actor, Actor}
          when is_record(Actor, actor)
               -> room(room:add(Room, Actor));
        {update_actors} ->
            room:update_actors(Room),
            room(Room);
        terminate -> ok
    end.

update_actors(Room) ->
    lists:map(fun({Pid, _}) -> Pid ! {update_view, Room} end,
              Room#room.actors),
    ok.
              
