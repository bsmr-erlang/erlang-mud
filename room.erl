-module(room).
-export([start/1,
         add/2
         ]).
-include("room.hrl").
-include("item.hrl").

start(Room) -> fail.

create(Text, Items) ->
    #room{text=Text, items=Items}.

add(Room, Item) when is_record(Item, item) ->
    Items=Room#room.items,
    Room#room{items=[Item|Items]
         }.



