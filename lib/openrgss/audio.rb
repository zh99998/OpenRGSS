module Audio
  class <<self
    def setup_mdi

    end

    def bgm_play(filename, volume=100, pitch=100, pos=0)
      SDL::Mixer.play_music SDL::Mixer::Music.load(RGSS.get_file(filename)), -1
    end

    def bgm_stop
      SDL::Mixer.halt_music
    end

    def bgm_fade(time)
      SDL::Mixer.fade_out_music(time)
    end

    def bgm_pos

    end

    def bgs_play(filename, volume=100, pitch=100, pos=0)
      @bgs_channel = SDL::Mixer.play_channel(-1, SDL::Mixer::Wave.load(RGSS.get_file(filename)), -1)
    end

    def bgs_stop
      SDL::Mixer.halt(@bgs_channel) if @bgs_channel
    end

    def bgs_fade(time)
      SDL::Mixer.fade_out(@bgs_channel, time) if @bgs_channel
    end

    def bgs_pos

    end

    def me_play(filename, volume=100, pitch=100)
      @me_channel = SDL::Mixer.play_channel(-1, SDL::Mixer::Wave.load(RGSS.get_file(filename)), 0)
    end

    def me_stop
      SDL::Mixer.halt(@me_channel) if @me_channel
    end

    def me_fade(time)
      SDL::Mixer.fade_out(@me_channel, time) if @me_channel
    end

    def se_play(filename, volume=100, pitch=100)
      @se_channel = SDL::Mixer.play_channel(-1, SDL::Mixer::Wave.load(RGSS.get_file(filename)), 0)
    end

    def se_stop
      SDL::Mixer.halt(@se_channel) if @me_channel
    end
  end
end