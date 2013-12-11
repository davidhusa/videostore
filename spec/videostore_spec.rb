require "#{File.dirname(__FILE__)}/../lib/videostore"

describe VideoStore::Youtube do
  before :each do
    @youtube = VideoStore::Youtube.new('vWeaOG6KzqE')
    @invalid_youtube = VideoStore::Youtube.new('imnotavalididlol')
    @vimeo = VideoStore::Vimeo.new(39605750)
    @invalid_vimeo = VideoStore::Vimeo.new(5)
  end
  context 'youtube' do
    it "can tell when a video is and isn't there, and what it is" do
      @youtube.present?.should == true
      @invalid_youtube.present?.should == false
      @youtube.youtube?.should == true
      @youtube.vimeo?.should == false
    end

    it "can pull down information" do
      @youtube.video_id.should == "vWeaOG6KzqE"
      @youtube.title.should == "Madeon | The incomplete mix | Not All tracks | Adio"
      @youtube.thumbnail_uri.should == "https://i1.ytimg.com/vi/vWeaOG6KzqE/default.jpg"
      @youtube.channel_name.should == "Adio Music"
      @youtube.duration.should == 3306
      @youtube.views.should > 350223
    end
  end
  
  context 'vimeo' do
    it "can tell when a video is and isn't there" do
      @vimeo.present?.should == true
      @invalid_vimeo.present?.should == false
      @vimeo.vimeo?.should == true 
      @vimeo.youtube?.should == false
    end

    it "can pull down information" do
      @vimeo.video_id.should == 39605750
      @vimeo.title.should == "woot woot"
      @vimeo.thumbnail_uri.should == "http://b.vimeocdn.com/ts/273/226/273226915_640.jpg"
      @vimeo.channel_name.should == "Cole Ruffing"
      @vimeo.duration.should == 243
      @vimeo.views.should > 1356
    end
  end

  context 'collection' do
    it 'can sort collections' do
      @sort_by_title = [@vimeo, @youtube].sort_by! {|x| x.title }
      @sort_by_title[0].youtube?.should == true

      @sort_by_channel_name = [@vimeo, @youtube].sort_by! {|x| x.channel_name }
      @sort_by_channel_name[0].youtube?.should == true

      @sort_by_duration = [@vimeo, @youtube].sort_by! {|x| x.views }
      @sort_by_duration[0].vimeo?.should == true
    end
  end  
end
