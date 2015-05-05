-module(more_videos_handler).
-include("includes.hrl").
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
	{PageBinary, _} = cowboy_req:qs_val(<<"p">>, Req),
	PageNum = list_to_integer(binary_to_list(PageBinary)),
	SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,
	{CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	Category = binary_to_list(CategoryBinary),
	Url_more_news = celebrityinn_util:more_videos(Category, integer_to_list(?NEWS_PER_PAGE), integer_to_list(SkipItems)), 	
	% io:format("url-> ~p ~n",[Url_more_news]),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_more_news,[],get,[],[]),
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
	{ok, Body} = more_videos_dtl:render([{<<"videoParam">>,VideoParams},{<<"news_category">>,Category},{<<"allnews">>,ParamsAllNews}]),
    {Body, Req, State}.



