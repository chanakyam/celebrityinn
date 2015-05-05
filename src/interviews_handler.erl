-module(interviews_handler).
-author("chanakyam@koderoom.com").

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
	{[{_,Value}], Req2} = cowboy_req:bindings(Req),
	%Url = starstyle_util:interviews_item_url(binary_to_list(Value)), 
	%io:format("url: ~p~n",[Url]), 
	%{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	%Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	%Params = jsx:decode(list_to_binary(Res)),	
	%{ok, Body} = interviews_dtl:render([{<<"newsParam">>,Params}]),
    %{Body, Req2, State}.


    Url_news = celebrityinn_util:interviews_item_url(binary_to_list(Value)), 
	%io:format("url: ~p~n",[Url]),
	Url = celebrityinn_util:thumb_title_video_count(binary_to_list(<<"full_composite_article">>),binary_to_list(<<"1">>),binary_to_list(<<"10">>)),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),	
	ResponseParams = jsx:decode(list_to_binary(Res)),
	[ResponseRows] = proplists:get_value(<<"rows">>, ResponseParams),
	Params = proplists:get_value(<<"value">>, ResponseRows),
	{ok, "200", _, ResponseNews} = ibrowse:send_req(Url_news,[],get,[],[]),
	ResNews = string:sub_string(ResponseNews, 1, string:len(ResponseNews) -1 ),
	ParamsNews = jsx:decode(list_to_binary(ResNews)),
	%io:format("params ~p ~n ",[ParamsNews]),	
	{ok, Body} = interviews_dtl:render([{<<"videoParam">>,Params},{<<"newsParam">>,ParamsNews}]),
    {Body, Req2, State}.


