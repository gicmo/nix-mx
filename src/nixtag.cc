#include "nixtag.h"
#include "nixgen.h"

#include "mex.h"

#include <nix.hpp>

#include "handle.h"
#include "arguments.h"
#include "struct.h"

namespace nixtag {

    void describe(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);

        struct_builder sb({ 1 }, { "id", "type", "name", "definition", "position", "extent", "units" });

        sb.set(currObj.id());
        sb.set(currObj.type());
        sb.set(currObj.name());
        sb.set(currObj.definition());
        sb.set(currObj.position());
        sb.set(currObj.extent());
        sb.set(currObj.units());

        output.set(0, sb.array());
    }

    void open_data_array(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::open_data_array(currObj.getReference(input.str(2))));
    }

    void list_references_array(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::list_data_arrays(currObj.references()));
    }

    void list_features(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::list_features(currObj.features()));
    }

    void list_sources(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::list_sources(currObj.sources()));
    }

    void open_feature(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::open_feature(currObj.getFeature(input.str(2))));
    }

    void open_source(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::open_source(currObj.getSource(input.str(2))));
    }

    void has_metadata_section(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::has_metadata_section(currObj.metadata()));
    }

    void open_metadata_section(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        output.set(0, nixgen::open_metadata_section(currObj.metadata()));
    }

    void references(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        std::vector<nix::DataArray> arr = currObj.references();

        const mwSize size = static_cast<mwSize>(arr.size());
        mxArray *lst = mxCreateCellArray(1, &size);

        for (size_t i = 0; i < arr.size(); i++) {
            mxSetCell(lst, i, make_mx_array(handle(arr[i])));
        }

        output.set(0, lst);
    }

    void features(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        std::vector<nix::Feature> arr = currObj.features();

        const mwSize size = static_cast<mwSize>(arr.size());
        mxArray *lst = mxCreateCellArray(1, &size);

        for (size_t i = 0; i < arr.size(); i++) {
            mxSetCell(lst, i, make_mx_array(handle(arr[i])));
        }

        output.set(0, lst);
    }

    void sources(const extractor &input, infusor &output)
    {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        std::vector<nix::Source> arr = currObj.sources();

        const mwSize size = static_cast<mwSize>(arr.size());
        mxArray *lst = mxCreateCellArray(1, &size);

        for (size_t i = 0; i < arr.size(); i++) {
            mxSetCell(lst, i, make_mx_array(handle(arr[i])));
        }

        output.set(0, lst);
    }

    void retrieve_data(const extractor &input, infusor &output) {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        double index = input.num<double>(2);

        mxArray *data = make_mx_array(currObj.retrieveData(index));
        output.set(0, data);
    }

    void retrieve_feature_data(const extractor &input, infusor &output) {
        nix::Tag currObj = input.entity<nix::Tag>(1);
        double index = input.num<double>(2);

        mxArray *data = make_mx_array(currObj.retrieveFeatureData(index));
        output.set(0, data);
    }

} // namespace nixtag
