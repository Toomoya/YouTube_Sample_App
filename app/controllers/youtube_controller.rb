class YoutubeController < ApplicationController

  def index
    @youtube = Youtube.new
    @youtubes = Youtube.all.order(id: "DESC").page(params[:page]).per(10)
  end

  def create
    @youtube = Youtube.new(youtube_params)
    if @youtube.save
      redirect_to youtube_path(@youtube.id)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @youtube = Youtube.find(params[:id])
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    @artist = @youtube.artist
    @song = @youtube.song
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = Addressable::URI.parse("https://www.googleapis.com/youtube/v3/search?key="+ENV['YOUTUBE_API_KEY']+"&q="+@artist.gsub(" ", "")+@song.gsub(" ", "")+"&part=id,snippet")
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query
    http = Net::HTTP.new(uri.host, uri.inferred_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(request)
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case res
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        @result = JSON.parse(res.body)
        # 表示用の変数に結果を格納
        @videoId1 = @result["items"][0]["id"]["videoId"]
        @videoId2 = @result["items"][1]["id"]["videoId"]
        @videoId3 = @result["items"][2]["id"]["videoId"]

      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end

  private
  def youtube_params
    params.require(:youtube).permit(:song, :artist)
  end

end
