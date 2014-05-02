Deface::Override.new(:virtual_path  => 'spree/admin/shared/_configuration_menu',
                     :name          => 'add_mail_chimp_admin_menu_link',
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
                     :text          => %q{ <%= configurations_sidebar_menu_item 'MailChimp', admin_mail_chimp_settings_path %> } ,
                     :original      => '2cf96f0a9fa40fbacd5c62d0d2e2da554965526d')
