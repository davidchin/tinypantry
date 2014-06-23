module AssetHelper
  def asset_manifest
    path = Dir[Rails.root.join('public', 'assets', 'manifest*.json').to_s].first
    path ? JSON.parse(File.read(path)) : {}
  end

  def asset_manifest_json
    asset_manifest.to_json.html_safe
  end
end
