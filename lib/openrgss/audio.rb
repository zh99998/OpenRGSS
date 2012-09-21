# The module that carries out music and sound processing.
module Audio
  class <<self

    # Prepares MIDI playback by DirectMusic.
    #
    # A method of the processing at startup in RGSS2 for enabling execution at any time.
    #
    # MIDI playback is possible without calling this method, but in Windows Vista or later, a delay of 1 to 2 seconds will result at playback.

    def setup_mdi

    end

    # Starts BGM playback. Specifies the file name, volume, pitch, and playback starting position in that order.
    #
    # The playback starting position (RGSS3) is only valid for ogg or wav files.
    #
    # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.

    def bgm_play(filename, volume=100, pitch=100, pos=0)
      SDL::Mixer.play_music SDL::Mixer::Music.load(RGSS.get_file(filename)), -1 rescue puts($!)
    end

    # Stops BGM playback.

    def bgm_stop
      SDL::Mixer.halt_music
    end

    # Starts BGM fadeout. time is the length of the fadeout in milliseconds.

    def bgm_fade(time)
      SDL::Mixer.fade_out_music(time)
    end

    # Gets the playback position of the BGM. Only valid for ogg or wav files. Returns 0 when not valid.

    def bgm_pos

    end

    # Starts BGS playback. Specifies the file name, volume, pitch, and playback starting position in that order.
    #
    # The playback starting position (RGSS3) is only valid for ogg or wav files.
    #
    # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.

    def bgs_play(filename, volume=100, pitch=100, pos=0)
      @bgs_channel = SDL::Mixer.play_channel(-1, SDL::Mixer::Wave.load(RGSS.get_file(filename)), -1) rescue puts($!)
    end

    # Stops BGS playback.

    def bgs_stop
      SDL::Mixer.halt(@bgs_channel) if @bgs_channel
    end

    # Starts BGS fadeout. time is the length of the fadeout in milliseconds.

    def bgs_fade(time)
      SDL::Mixer.fade_out(@bgs_channel, time) if @bgs_channel
    end

    # Gets the playback position of the BGS. Only valid for ogg or wav files. Returns 0 when not valid.

    def bgs_pos

    end

    # Starts ME playback. Sets the file name, volume, and pitch in turn.
    #
    # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
    #
    # When ME is playing, the BGM will temporarily stop. The timing of when the BGM restarts is slightly different from RGSS1.

    def me_play(filename, volume=100, pitch=100)
      @me_channel = SDL::Mixer.play_channel(-1, SDL::Mixer::Wave.load(RGSS.get_file(filename)), 0) rescue puts($!)
    end

    # Stops ME playback.

    def me_stop
      SDL::Mixer.halt(@me_channel) if @me_channel
    end

    # Starts ME fadeout. time is the length of the fadeout in milliseconds.

    def me_fade(time)
      SDL::Mixer.fade_out(@me_channel, time) if @me_channel
    end

    # Starts SE playback. Sets the file name, volume, and pitch in turn.
    #
    # Also automatically searches files included in RGSS-RTP. File extensions may be omitted.
    #
    # When attempting to play the same SE more than once in a very short period, they will automatically be filtered to prevent choppy playback

    def se_play(filename, volume=100, pitch=100)
      @se_channel = SDL::Mixer.play_channel(-1, SDL::Mixer::Wave.load(RGSS.get_file(filename)), 0) rescue puts($!)
    end

    # Stops all SE playback.

    def se_stop
      SDL::Mixer.halt(@se_channel) if @me_channel
    end
  end
end