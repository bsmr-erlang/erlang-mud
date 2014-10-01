-module(client).
-export([run/0]).

run() ->
    Player = join_a_game(),
    run_input(Player),
    ok.
    % spawn(fun() -> run_input(Player) end).

run_input(Player) ->
    Input = read(),
    case Input of
        unknown ->
            io:format("unknown input ~s", [Input]),
            run_input(Player);
        quit ->
            eval(Player, quit);
        Command -> 
            eval(Player, Command),
            run_input(Player)
    end.


find_game() -> find_game(mud_server).

-spec(find_game(atom()) -> pid()).
find_game(Server) ->
    Existing = whereis(Server),
    case Existing of
        undefined ->
            start_game(Server);
        _ ->
            Existing
    end.

start_game(Server) ->
    Game = server:start(),
    register(Server, Game),
    Game.

join_a_game() ->
    Game = find_game(),
    join(Game).

join(Game) ->
    Name = get_name(),
    join(Game, Name).

join(Game, Name) ->
    Player = actor_proc:start(actor:create(Name)),
    server:add_actor(Game, Player),
    Player.

get_name() ->
    prompt("Your name> ").

prompt(Prompt) ->
    Raw = io:get_line(Prompt),
    %% Odd incantation to strip trailing "\n"s
    case Raw of
        "" -> "";
        _ -> hd(string:tokens(Raw, "\n")++[""])
    end.

read() ->
    parse(prompt("What now> ")).

parse(Text) ->
    LText = string:to_lower(Text),
    case LText of
        "north" -> {move, north};
        "south" -> {move, south};
        "east" -> {move, east};
        "west" -> {move, west};
        "n" -> {move, north};
        "s" -> {move, south};
        "e" -> {move, east};
        "w" -> {move, west};
        "quit" -> quit;
        "leave" -> quit;
        _ -> unknown
    end .

eval(Player, Command) ->
    Player ! {command, self(), Command}.




