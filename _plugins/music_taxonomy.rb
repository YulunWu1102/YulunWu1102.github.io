# _plugins/music_taxonomy.rb
module Jekyll
    class MusicTaxonomyPage < Page
    def initialize(site, base, dir, taxonomy, term)
        @site = site
        @base = base
        @dir  = dir
        @name = "index.html"

        process(@name)
        read_yaml(File.join(base, "_layouts"), "music_taxonomy.liquid")
        data["title"]    = term
        data["term"]     = term
        data["taxonomy"] = taxonomy # "tag" or "category"
    end
end

class MusicTaxonomyGenerator < Generator
    safe true
    priority :low

    def generate(site)
            music_collection = site.collections["music"]
            return unless music_collection

            # NOTE: use .docs, not dig(...)
            music_docs = music_collection.docs

            tags = music_docs.flat_map { |d| Array(d.data["tags"]) }
                            .map(&:to_s).reject(&:empty?).uniq
            cats = music_docs.flat_map { |d| Array(d.data["categories"]) }
                            .map(&:to_s).reject(&:empty?).uniq

            tags.each do |t|
                dir = File.join("music", "tag", Jekyll::Utils.slugify(t))
                site.pages << MusicTaxonomyPage.new(site, site.source, dir, "tag", t)
            end

            cats.each do |c|
            dir = File.join("music", "category", Jekyll::Utils.slugify(c))
            site.pages << MusicTaxonomyPage.new(site, site.source, dir, "category", c)
            end
        end
    end
end
