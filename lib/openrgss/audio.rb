module Audio
  class <<self
    def setup_mdi

    end

    def bgm_play(filename, volume=100, pitch=100, pos=0)
      SDL::Mixer.set_volume_music(volume)
      SDL::Mixer.fade_in_music SDL::Mixer::Music.load(RGSS.get_file(filename)), -1, 800
    end

    def bgm_stop

    end

    def bgm_fade(time)

    end

    def bgm_pos

    end

    def bgs_play(filename, volume=100, pitch=100, pos=0)

    end

    def bgs_stop

    end

    def bgs_fade(time)

    end

    def bgs_pos

    end

    def me_play(filename, volume=100, pitch=100)

    end

    def me_stop

    end

    def me_fade(time)

    end

    def se_play(filename, volume=100, pitch=100)

    end

    def se_stop

    end
  end
end