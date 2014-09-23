-module(client).
-export([run/0]).

run() ->
    Player = join_a_game(),
    spawn(fun() -> run_input(Player) end).

run_input(Player) ->
    Input = read(),
    case Input of
        {ok, Command} -> 
            eval(Player, Command);
        Unknown -> io:format("unknown input ~s", Unknown)
    end,
    run_input(Player).


find_game() -> find_game(mud_server).

find_game(Server) ->
    Existing = whereis(Server),
    if Existing == undefined ->
           start_game(Server);
       true ->
           Existing
    end.

start_game(Server) ->
    Game = server:start(),
    register(Server, Game),
    Game.

join_a_game() ->
    Game = find_game(),
    Name = get_name(),
    join(Game, Name).

join(Game, Name) ->
    Player = actor:create(Name),
    game:add(Game, Player),
    Player.

get_name() ->
    prompt("Your name> ").

prompt(Prompt) ->
    Raw = io:get_line(Prompt),
    hd(string:tokens(Raw, "\n")).

read() ->
    parse(prompt("What now> ")).

parse(Text) ->
    LText = string:to_lower(Text),
    case LText of
        "north" -> north;
        "n" -> north
    end .

eval(Player, Command) ->
    Player ! Command.




