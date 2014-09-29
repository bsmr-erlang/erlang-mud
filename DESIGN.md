A MUD written in Erlang.

# Processes
## Client
Sends:
- say "blah"
- move north
- take key
- open door

Receives:
- Room updates to print


## Actor
Is the server side representation of a character, be it player or ai.
Sends:
- relays room views,
- converts commands to individual steps (take key -> remove key from room, add key to player)

Receives:
- say "blah"
- move north
- take key
- open door


## Room
Sends:
- update_view -> all actors

receives:
- give_item(name, dest) -> dest ! {item, itemRef}
- actorEnters -> update_actore



# Basic processes
## Moving north

- player/ai sends {self(), move, north} to server
- server looks up room pid by current rom and direction
- server sends {move_actor_to, new_room_pid, ActorPid} to room
- source room receives that, removes player and sends NewRoom!{add_actor, ActorPid}
- dest room receives this add_Actor and recordsd the new lcoation of the actor.

?? Who tells the actor where it is?
- room that added it?
  - YES. The room that sends out an update will send it out as Actor ! {you_are_in_room, Room} % Room is a record with details of what's there.
- server that chose which room pid to send it to?



