# frozen_string_literal: true

load(Rails.root.join('db/seeds/development.rb')) if Rails.env.development?

License.create!([
                  { code: 'all_rights_reserved', source: nil, label: 'All Rights Reserved' },
                  { code: 'by', source: 'https://creativecommons.org/licenses/by/4.0/', label: 'Attribution' },
                  { code: 'by_sa', source: 'https://creativecommons.org/licenses/by-sa/4.0/',
                    label: 'Attribution-ShareAlike 4.0 International' },
                  { code: 'by_nc', source: 'https://creativecommons.org/licenses/by-nc/4.0/',
                    label: 'Attribution-NonCommercial' },
                  { code: 'by_nc_sa', source: 'https://creativecommons.org/licenses/by-nc-sa/4.0/',
                    label: 'Attribution-NonCommercial-ShareAlike' },
                  { code: 'by_nd', source: 'https://creativecommons.org/licenses/by-nd/4.0/',
                    label: 'Attribution-NoDerivs' },
                  { code: 'by_nc_nd', source: 'https://creativecommons.org/licenses/by-nc-nd/4.0/',
                    label: 'Attribution-NonCommercial-NoDerivs' },
                  { code: 'cc_0', source: 'https://creativecommons.org/publicdomain/zero/1.0/', label: 'No Copyright' }
                ])
