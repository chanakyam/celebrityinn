-module(all_interviews_handler).
-author("chanakyam@koderoom.com").
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
	%{[{_,Value}], Req2} = cowboy_req:bindings(Req),
	{PageBinary, _} = cowboy_req:qs_val(<<"p">>, Req),
	PageNum = list_to_integer(binary_to_list(PageBinary)),
	SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,

	{CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	Category = binary_to_list(CategoryBinary),
	%Url_all_news = starstyle_util:interviews_top_text_news_by_category_with_limit_and_skip(Category, integer_to_list(?NEWS_PER_PAGE), integer_to_list(SkipItems)), 
	%ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	%ResAllNews = string:sub_string(ResponseAllNews, 1, string:len(ResponseAllNews) -1 ),
	%[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,ParamsAllNews}] = jsx:decode(list_to_binary(ResAllNews)),
	%io:format("params ~p ~n ",[ParamsAllNews]),	
	%{ok, Body} = all_interviews_paginated_dtl:render([{<<"news_category">>,Category},{<<"allnews">>,ParamsAllNews}]),
    %{Body, Req, State}.


    Url_all_news = celebrityinn_util:interviews_top_text_news_by_category_with_limit_and_skip(Category, integer_to_list(?NEWS_PER_PAGE), integer_to_list(SkipItems)), 
	% io:format("url ~p ~n ",[Url_all_news]),	
	Url = celebrityinn_util:thumb_title_video_count(binary_to_list(<<"full_composite_article">>),binary_to_list(<<"1">>),binary_to_list(<<"6">>)),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),	
	ResponseParams = jsx:decode(list_to_binary(Res)),
	[ResponseRows] = proplists:get_value(<<"rows">>, ResponseParams),
	Params = proplists:get_value(<<"value">>, ResponseRows),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResAllNews = string:sub_string(ResponseAllNews, 1, string:len(ResponseAllNews) -1 ),
	[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,ParamsAllNews}] = jsx:decode(list_to_binary(ResAllNews)),
	%io:format("params ~p ~n ",[ParamsAllNews]),	
	{ok, Body} = all_interviews_paginated_dtl:render([{<<"videoParam">>,Params},{<<"news_category">>,Category},{<<"allnews">>,ParamsAllNews}]),
    {Body, Req, State}.




