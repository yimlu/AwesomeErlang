%%%----------------------------------------------------------------------------
%%% @author Yiming.Lu <luyiming2009@gmail.com>
%%% [http://www.xemi.org]
%%% @copyright 2016 XEMI.ORG
%%% @doc An IM middleware written in Erlang.
%%% @end
%%%----------------------------------------------------------------------------

-module(xmsg).

-behaviour(gen_server).

%% API
-export([
		start_link/1,
		start_link/0,
		get_count/0,
		stop/0
	]).

%% gen_server callbacks
-export([
		init/1,
		handle_call/3,
		handle_cast/2,
		handle_info/2,
		terminate/2,
		code_change/3]).

-define(SERVER, ?MODULE).
-define(DEFAULT_PORT,1055).

-record(state,{port,lsock,request_count=0}).

init([]) ->
	{ok,#state}.

handle_call(_Request,_From,State) ->
	Reply = ok,
	{reply,Reply,State}.

handle_cast(_Msg,State) ->
	{noreply,State}.

handle_info(_Info,State) ->
	{noreply,State}.

terminate(_Reason,_state) ->
	ok.

code_change(_OldVsn,State,_Extra) ->
	{ok,State}.


%%%============================================================================
%%% API
%%%============================================================================

%%-----------------------------------------------------------------------------
%% @doc Start server.
%%
%% @spec start_link(Port:: integer()) -> {ok,Pid}
%% where
%% Pid = pid()
%% @end
%%-----------------------------------------------------------------------------
start_link(Port) ->
	gen_server:start_link({local, ?SERVER},?MODULE,[Port], []).

%% @spec start_link() -> {ok,Pid}
%% @doc Calls `start_link(Port)` using the default port.
start_link() ->
	start_link(?DEFAULT_PORT).

%%-----------------------------------------------------------------------------
%% @doc Fetches the number of requests made to this server.
%% @spec get_count() -> {ok,Count}
%% where
%% Count = integer()
%% @end
%%-----------------------------------------------------------------------------
get_count() ->
	gen_server:call(?SERVER,get_count).

%%-----------------------------------------------------------------------------
%% @doc Stop the server.
%% @spec stop -> ok
%% @end
%%-----------------------------------------------------------------------------
stop ->
	gen_server:cast(?SERVER,stop).


%%%============================================================================
%%% gen_server callbacks
%%%============================================================================

init([Port]) ->
	{ok,LSock} = gen_tcp:listen(Port,[{active,true}]),% init server
	{ok,#state{port=Port,lsock=LSock},0}.


