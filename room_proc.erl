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
               -> room(room:add_item(Room, Item));
        {add_actor, Actor}
          when is_record(Actor, actor)
               -> room(room:add(Room, Actor));
        {move_actor, Actor, Dir} ->
            case room:get_exit(Dir) of
                {error, _} -> room(Room);
                ToRoom ->
                    case room:remove_actor(Room, Actor) of
                        {error, _} -> room(Room);
                        ChangedRoom -> 
                            ToRoom ! {add_actor, Actor},
                            room(ChangedRoom)
                    end
            end;
        {update_actors} ->
            room(room:update_actors(Room));
        terminate -> ok
    end.

update_actors(Room) ->
    lists:map(fun({Pid, _}) -> Pid ! {update_view, Room} end,
              Room#room.actors),
    ok.
              
