{
  config,
  lib,
  ...
}: let
  cfg = config.custom.programs.bottom;
in {
  options.custom.programs.bottom.enable = lib.mkEnableOption "Enable bottom";

  config = lib.mkIf cfg.enable {
    programs.bottom = {
      enable = true;
      settings = {
        # https://github.com/catppuccin/bottom/blob/main/themes/mocha.toml
        styles = with config.lib.stylix.colors.withHashtag; {
          cpu = {
            all_entry_color = base06;
            avg_entry_color = "#eba0ac";
            cpu_core_colors = [base08 base09 base0A base0B "#74c7ec" base0E];
          };
          memory = {
            ram_color = base0B;
            cache_color = base08;
            swap_color = base09;
            gpu_colors = ["#74c7ec" base0E base08 base09 base0A base0B];
            arc_color = "#89dceb";
          };
          network = {
            rx_color = base0B;
            tx_color = base08;
            rx_total_color = "#89dceb";
            tx_total_color = base0B;
          };
          battery = {
            high_battery_color = base0B;
            medium_battery_color = base0A;
            low_battery_color = base08;
          };
          tables = {
            headers.color = base06;
          };
          graphs = {
            graph_color = "#a6adc8";
            legend_text.color = "#a6adc8";
          };
          widgets = {
            border_color = base04;
            selected_border_color = "#f5c2e7";
            widget_title.color = base0F;
            text.color = base05;
            selected_text = {
              color = "#11111b";
              bg_color = base0E;
            };
            disabled_text.color = base00;
          };
        };
      };
    };
  };
}
