final: prev:

{
  vaapiIntel = prev.vaapiIntel.override {
    enableHybridCodec = true;
  };
}
