{
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 1.0;
    longitude = 103.0;
    temperature = {
      day = 5000;
      night = 4000;
    };
    settings = { general.adjustment-method = "wayland"; };
  };
}
