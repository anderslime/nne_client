module NNEClient
  class Query
    def initialize(query_hash, xml)
      @query_hash = query_hash
      @xml = xml
    end

    def render
      Question.new(@query_hash, @xml).render
      @xml.int_2(hits_per_page, 'xsi:type' => "xsd:int")
      @xml.int_3(wanted_page_number, 'xsi:type' => "xsd:int")
      @xml.int_4(include_ad_protected, 'xsi:type' => "xsd:int")
      @xml.String_5(nil, 'xsi:type' => "xsd:string")
    end

    def include_ad_protected
      @query_hash[:includeAdProtected] || 0
    end

    def hits_per_page
      @query_hash[:hitsPerPage] || 10
    end

    def wanted_page_number
      @query_hash[:wantedPageNumber] || 1
    end
  end
end
