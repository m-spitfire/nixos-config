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
        styles = with config.lib.stylix; {
          cpu = {
            all_entry_color = colors.base06;
            avg_entry_color = "#eba0ac";
            cpu_core_colors = [colors.base08 colors.base09 colors.base0A colors.base0B "#74c7ec" colors.base0E];
          };
          memory = {
            ram_color = colors.base0B;
            cache_color = colors.base08;
            swap_color = colors.base09;
            gpu_colors = ["#74c7ec" colors.base0E colors.base08 colors.base09 colors.base0A colors.base0B];
            arc_color = "#89dceb";
          };
          network = {
            rx_color = colors.base0B;
            tx_color = colors.base08;
            rx_total_color = "#89dceb";
            tx_total_color = colors.base0B;
          };
          battery = {
            high_battery_color = colors.base0B;
            medium_battery_color = colors.base0A;
            low_battery_color = colors.base08;
          };
          tables = {
            headers.color = colors.base06;
          };
          graphs = {
            graph_color = "#a6adc8";
            legend_text.color = "#a6adc8";
          };
          widgets = {
            border_color = colors.base04;
            selected_border_color = "#f5c2e7";
            widget_title.color = colors.base0F;
            text.color = colors.base05;
            selected_text = {
              color = "#11111b";
              bg_color = colors.base0E;
            };
            disabled_text.color = colors.base00;
          };
        };
      };
    };
  };
}
