-module(photo_gallery_handler).

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
	
 
 	{CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
 	Category = binary_to_list(CategoryBinary),
 	Url_all_news = celebrityinn_util:photo_gallery_list(Category),
 	%io:format("url: ~p~n",[Url_all_news]),  
 	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
 	ResAllNews = string:sub_string(ResponseAllNews, 1, string:len(ResponseAllNews) -1 ),
 	[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,ParamsAllNews}] = jsx:decode(list_to_binary(ResAllNews)),
 	%io:format("params ~p ~n ",[ParamsAllNews]),
 	 % for video display
	Url = celebrityinn_util:video_count(binary_to_list(<<"full_composite_article">>),binary_to_list(<<"1">>),binary_to_list(<<"2">>)),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),	
	ResponseParams = jsx:decode(list_to_binary(Res)),
	[ResponseRows] = proplists:get_value(<<"rows">>, ResponseParams),
	VideoParams = proplists:get_value(<<"value">>, ResponseRows),	
 	{ok, Body} = photo_gallery_dtl:render([{<<"videoParam">>,VideoParams},{<<"news_category">>,Category},{<<"allnews">>,ParamsAllNews}]),
 		{Body, Req, State}.	