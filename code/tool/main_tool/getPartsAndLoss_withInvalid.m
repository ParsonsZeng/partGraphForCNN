function [parts,gen]=getPartsAndLoss_withInvalid(Loss,parts)
layerNum=length(parts.layer);
gen(layerNum).depth=[];
for layer=layerNum:-1:1
    depthNum=size(Loss(layer).Gen.SUM,2);
    theTar=repmat(struct('SUM',[],'local',[],'geo',[]),[1,depthNum]);
    gen_N=Loss(layer).Gen.N;
    parGen_N=repmat(gen_N,[1,depthNum]);
    thePart=parts.layer(layer).depth;
    theGen_SUM=Loss(layer).Gen.SUM;
    theGen_local=Loss(layer).Gen.local;
    theGen_geo=Loss(layer).Gen.geo;
    parfor par=1:depthNum
        part=thePart(par);
        part.validNum=numel(part.nodeRank); %%%%%%%%%%%%%%
        thePart(par)=part;
        vList=part.nodeRank;
        ptmp=theGen_SUM(:,par);
        theTar(par).SUM=ptmp(vList)./parGen_N(par);
        ptmp=theGen_local(:,par);
        theTar(par).local=ptmp(vList)./parGen_N(par);
        ptmp=theGen_geo(:,par);
        theTar(par).geo=ptmp(vList)./parGen_N(par);
    end
    gen(layer).depth=theTar;
    parts.layer(layer).depth=thePart;
end
end
