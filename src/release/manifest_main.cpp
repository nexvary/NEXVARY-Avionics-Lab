#include "release/ReleaseManifest.hpp"
#include <fstream>
#include <iostream>

int main(int argc,char** argv){const auto json=nexvary::avionics::build::ReleaseManifest::toJson();if(argc>2){std::cerr<<"usage: nexvary_release_manifest [output.json]\n";return 2;}if(argc==2){std::ofstream out(argv[1],std::ios::binary);if(!out){std::cerr<<"cannot open manifest output\n";return 1;}out<<json<<'\n';return out.good()?0:1;}std::cout<<json<<'\n';return 0;}
