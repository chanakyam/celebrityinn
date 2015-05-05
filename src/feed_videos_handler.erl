-module(feed_videos_handler).

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{Category, _ } = cowboy_req:qs_val(<<"c">>, Req),
	% io:format("category-> ~p~n",[Category]), 
	{Limit, _ } = cowboy_req:qs_val(<<"l">>, Req),
	{Skip, _ } = cowboy_req:qs_val(<<"skip">>, Req),
	Url = celebrityinn_util:video_count(binary_to_list(Category), binary_to_list(Limit), binary_to_list(Skip)),
	% io:format("Url ~p ~n",[Url]),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Body = list_to_binary(Res),
	{Body, Req, State}.

