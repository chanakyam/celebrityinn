-module(tnc_page_handler).
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
% 	{ok, Body} = tnc_dtl:render(),
%     {Body, Req, State}
% .

Url = celebrityinn_util:video_count(binary_to_list(<<"full_composite_article">>),binary_to_list(<<"1">>),binary_to_list(<<"2">>)),
	%io:format("url: ~p~n",[Url]), 
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),	
	ResponseParams = jsx:decode(list_to_binary(Res)),
	[ResponseRows] = proplists:get_value(<<"rows">>, ResponseParams),
	Params = proplists:get_value(<<"value">>, ResponseRows),
	%io:format("params ~p ~n ",[Params]),	
	{ok, Body} = tnc_dtl:render([{<<"videoParam">>,Params}]),
    {Body, Req, State}.