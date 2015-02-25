classdef Block < nix.NamedEntity
    %Block nix Block object
    
    properties (Access = protected)
        % namespace reference for nix-mx functions
        alias = 'Block'
        
        % dynamically assigned attrs
        dynamic_attrs = {
            struct('name', 'dataArrayCount', 'mode', 'r'), ...
            struct('name', 'sourceCount', 'mode', 'r'), ...
            struct('name', 'tagCount', 'mode', 'r'), ...
            struct('name', 'multiTagCount', 'mode', 'r'), ...
        }
    end
    
    properties(Hidden)
        dataArraysCache
        sourcesCache
        tagsCache
        multiTagsCache
        metadataCache
    end;
    
    properties(Dependent)
        dataArrays
        sources
        tags
        multiTags
    end;
    
    methods
        function obj = Block(h)
            obj@nix.NamedEntity(h);

            obj.dataArraysCache.lastUpdate = 0;
            obj.dataArraysCache.data = {};
            obj.sourcesCache.lastUpdate = 0;
            obj.sourcesCache.data = {};
            obj.tagsCache.lastUpdate = 0;
            obj.tagsCache.data = {};
            obj.multiTagsCache.lastUpdate = 0;
            obj.multiTagsCache.data = {};
            obj.metadataCache.lastUpdate = 0;
            obj.metadataCache.data = {};
        end;
        
        % -----------------
        % DataArray methods
        % -----------------
        
        function das = list_data_arrays(obj)
            das = nix_mx('Block::listDataArrays', obj.nix_handle);
        end;
        
        function da = data_array(obj, id_or_name)
           dh = nix_mx('Block::openDataArray', obj.nix_handle, id_or_name); 
           da = nix.DataArray(dh);
        end;
        
        function da = get.dataArrays(obj)
            [obj.dataArraysCache, da] = nix.Utils.fetchObjList(obj.updatedAt, ...
                'Block::dataArrays', obj.nix_handle, obj.dataArraysCache, @nix.DataArray);
        end;
        
        % -----------------
        % Sources methods
        % -----------------
        
        function sourcesList = list_sources(obj)
            sourcesList = nix_mx('Block::listSources', obj.nix_handle);
        end;

        function source = open_source(obj, id_or_name)
           sh = nix_mx('Block::openSource', obj.nix_handle, id_or_name); 
           source = nix.Source(sh);
        end;

        function sources = get.sources(obj)
            [obj.sourcesCache, sources] = nix.Utils.fetchObjList(obj.updatedAt, ...
                'Block::sources', obj.nix_handle, obj.sourcesCache, @nix.Source);
        end;
        
        % -----------------
        % Tags methods
        % -----------------
        
        function hasTag = has_tag(obj, id_or_name)
            getHasTag = nix_mx('Block::hasTag', obj.nix_handle, id_or_name);
            hasTag = logical(getHasTag.hasTag);
        end;
        
        function tagList = list_tags(obj)
            tagList = nix_mx('Block::listTags', obj.nix_handle);
        end;
        
        function tag = open_tag(obj, id_or_name)
           tagHandle = nix_mx('Block::openTag', obj.nix_handle, id_or_name); 
           tag = nix.Tag(tagHandle);
        end;
        
        function tagList = list_multi_tags(obj)
            tagList = nix_mx('Block::listMultiTags', obj.nix_handle);
        end;
        
        function tags = get.tags(obj)
            [obj.tagsCache, tags] = nix.Utils.fetchObjList(obj.updatedAt, ...
                'Block::tags', obj.nix_handle, obj.tagsCache, @nix.Tag);
        end;
        
        % -----------------
        % MultiTag methods
        % -----------------
        
        function hasMTag = has_multi_tag(obj, id_or_name)
            getHasMTag = nix_mx('Block::hasMultiTag', obj.nix_handle, id_or_name);
            hasMTag = logical(getHasMTag.hasMultiTag);
        end;
        
        function tag = open_multi_tag(obj, id_or_name)
           tagHandle = nix_mx('Block::openMultiTag', obj.nix_handle, id_or_name); 
           tag = nix.MultiTag(tagHandle);
        end;
        
        function mtags = get.multiTags(obj)
            [obj.multiTagsCache, mtags] = nix.Utils.fetchObjList(obj.updatedAt, ...
                'Block::multiTags', obj.nix_handle, obj.multiTagsCache, @nix.MultiTag);
        end;
        
        % -----------------
        % Metadata methods
        % -----------------
        
        function hasMetadata = has_metadata(obj)
            getHasMetadata = nix_mx('Block::hasMetadataSection', obj.nix_handle);
            hasMetadata = logical(getHasMetadata.hasMetadataSection);
        end;
        
        function metadata = open_metadata(obj)
            [obj.metadataCache, metadata] = nix.Utils.fetchObj(obj.updatedAt, ...
                'Block::openMetadataSection', obj.nix_handle, obj.metadataCache, @nix.Section);
        end;

    end;
end