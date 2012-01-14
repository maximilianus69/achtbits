
function [AuthorizedOptions] = authoptions( filename )


%% all available options to each function


switch filename

    case {'ge_axes' }
        
        AuthorizedOptions = {'altitudeMode',...
                             'axesOrigin',...
                             'axesType',...
                             'hAxisLength',...
                             'hLineColor',...
                             'hTick',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'region',...
                             'xTick',...                    
                             'xyLineColor',...
                             'xzLineColor',...
                             'yTick',...
                             'yzLineColor',...
                             'zTick'};
                 
    case {'ge_barbdaes' }

        AuthorizedOptions = {'barbAlpha',...
                             'barbColor',...
                             'daeDir',...
                             'msgToScreen',...
                             'noWindWidth',...
                             'flagWidth',...
                             'flagLength',...
                             'pennantSeparation',...
                             'poleWidth',...
                             'longPennantLength',...
                             'pennantWidth',...
                             'shortPennantLength'};
               
    case {'ge_box' }
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'description',...
                             'extrude',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
                             'polyColor',...
			     'region',...
                             'snippet',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
    case {'ge_circle' }
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'description',...
                             'divisions',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
                             'nameVisibility',...
                             'polyColor',...
			     'region',...
                             'snippet',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
                 
    case {'ge_colorbar' }
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'cBarBorderWidth',...
                             'cBarFormatStr',...
                             'cLimHigh',...
                             'cLimLow',...
                             'colorMap',...
                             'extrude',... 
                             'iconScale',...
                             'labels',...
                             'lineValues',...
                             'msgToScreen',...      
                             'name',...
                             'nanValue',...
                             'numClasses',...
                             'region',...
                             'showNumbersColumn',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
               
    case {'ge_contour' }
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'cLimHigh',...
                             'cLimLow',...
                             'colorMap',...
                             'description',...
                             'extrude',...
                             'forceAsLine',...
                             'lineAlpha',...
                             'lineColor',...
                             'lineWidth',...
                             'lineValues',...
                             'msgToScreen',...
                             'numClasses',...
                             'name',...
                             'region',...
                             'snippet',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};

    case {'ge_contourf','ge_contourf_old'}
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'autoClose',...
                             'cLimHigh',...
                             'cLimLow',...
                             'colorMap',...
                             'extrude',...
                             'lineAlpha',...
                             'lineColor',...
                             'lineWidth',...
                             'lineValues',...
                             'msgToScreen',...
                             'nearInf',...
                             'name',...
                             'numClasses',...
                             'numClassesDefault',...
                             'region',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'tinyResFactor',...
                             'visibility',...
                             'vizProcessing',...
                             'polyAlpha'};
                         
    case {'ge_cylinder' }
        
        AuthorizedOptions = {'description',...
                             'divisions',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
                             'polyColor',...
			     'region',...
                             'snippet',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
                 
    case {'ge_gplot' }
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'description',...
                             'extrude',...
                             'forceAsLine',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...                     
                             'name',...
			     'region',...
                             'snippet',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};

    case {'ge_grid' }
        
        AuthorizedOptions = {'altitude', ...
                             'altitudeMode', ...
                             'description', ...
                             'extrude', ...
                             'lineWidth', ...
                             'lineColor', ...
                             'latRes', ...
                             'lonRes', ...
                             'name',...
                             'polyColor', ...
			     'region',...
                             'snippet', ...
                             'timeStamp', ...
                             'timeSpanStart', ...
                             'timeSpanStop',...
                             'visibility'};

    case {'ge_groundoverlay' }
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'color',...
                             'description',...
                             'imgURL',...
                             'msgToScreen',...
                             'name',...
                             'polyAlpha',...
                             'region',...
                             'rotation',...
                             'snippet',...
                             'timeStamp',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'viewBoundScale',...
                             'visibility'};

    
    case {'ge_imagesc_old' }
        
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'cLimHigh',...
                             'cLimLow',...
                             'cMap',...
                             'dataFormatStr',...
                             'description',...
                             'extrude',...
                             'imageURL',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
                             'nanValue',...
                             'polyAlpha',...
                             'region',...
                             'snippet',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility',...
                             'xResolution',...
                             'yResolution'};
                 
    case {'ge_imagesc' }
        
        AuthorizedOptions = {'alphaMatrix',...
                             'altitude',...
                             'altitudeMode',...
                             'cLimHigh',...
                             'cLimLow',...
                             'colorMap',...
                             'crispFactor',...
                             'description',...
                             'imgURL',...
                             'msgToScreen',...
                             'name',...
                             'nanValue',...
                             'nColors',...
                             'region',...
                             'snippet',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'visibility',...
                             'xResolution',...
                             'yResolution'};
                 

    case {'ge_kml' }
        
        AuthorizedOptions = {'name',...
                             'msgToScreen',...
                             'resourceURLs',...
                             'kmlTargetDir',...
                             'tmpDir'};
          
    case {'ge_kmz' }
        
        AuthorizedOptions = {'msgToScreen',...
                             'resourceURLs',...
                             'kmzTargetDir',...
                             'tmpDir'};

    case {'ge_output' }
        
        AuthorizedOptions = {'msgToScreen',...
                             'name'};
   case {'ge_screenoverlay'}
       
        AuthorizedOptions = {'color',...
                             'id',...
                             'name',...
                             'visibility',...
                             'snippet',...
                             'description',...
                             'drawOrder',...
                             'sizeWidth',...
                             'sizeWidthUnits',...
                             'sizeHeight',...
                             'sizeHeightUnits',...
                             'sizeLeft',...
                             'sizeLeftUnits',...
                             'sizeBottom',...
                             'sizeBottomUnits',...
                             'posLeft',...
                             'posLeftUnits',...
                             'posBottom',...
                             'posBottomUnits',...
                             'region',...
                             'rotation',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
                         
    case {'ge_plot3' }
        
        AuthorizedOptions = {'altitudeMode',...
                             'description',...
                             'extrude',...
                             'forceAsLine',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
			     'region',...
                             'snippet',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
    case {'ge_plot' }
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'snippet', ...
                             'description', ...
                             'extrude',...
                             'forceAsLine',...
                             'lineColor',...
                             'lineWidth', ...
                             'msgToScreen',...
                             'name',...
			     'region',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};

                 
    case {'ge_point'}
        
        AuthorizedOptions = {'altitudeMode',...
                             'dataFormatStr',...
                             'description',...
                             'extrude',...
                             'iconColor',...
                             'iconScale',...
                             'iconURL',...
                             'msgToScreen',...
                             'name',...
                             'pointDataCell',... 
                             'region',...
                             'snippet',...
                             'tableBorderWidth',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
    case {'ge_point_new'}
        
        AuthorizedOptions = {'altitudeMode',...
                             'dataFormatStr',...
                             'description',...
                             'extrude',...
                             'iconColor',...
                             'iconScale',...
                             'iconURL',...
                             'msgToScreen',...
                             'name',...
                             'pointDataCell',... 
                             'region',...     
                             'snippet',...
                             'tableBorderWidth',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};

    case {'ge_poly3'}
        
        AuthorizedOptions = {'altitudeMode',...
                             'autoClose',...
                             'description',...
                             'extrude',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
                             'polyColor',...
			     'region',...
                             'snippet',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
    case {'ge_poly'}
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'autoClose',...
                             'description',...
                             'extrude',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
                             'polyColor',...
			     'region',...
                             'snippet',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility',...
                             'innerBoundsStr'};
                 
    case {'ge_polyplace'}
        
        AuthorizedOptions = {
                             'altitude', ...
                             'altitudeMode', ...
                             'description', ...
                             'extrude', ...
                             'lineWidth', ...
                             'lineColor', ...
                             'msgToScreen',...
                             'name',...
                             'polyColor', ...
			     'region',...
                             'snippet',...
                             'tessellate', ...
                             'timeStamp', ...
                             'timeSpanStart', ...
                             'timeSpanStop', ...
                             'visibility'};
     case {'ge_region'}
	
	AuthorizedOptions = {
			     'id', ...
			     'minAltitude', ...
			     'maxAltitude', ...
			     'minLodPixels', ...
			     'maxLodPixels', ...
			     'minFadeExtent', ...
			     'maxFadeExtent'};

                
    case {'ge_quiver3'}

        AuthorizedOptions = {'altitudeMode',...
                             'arrowScale',...
                             'description',...
                             'fixedArrowLength',...
                             'modelLinkStr',...
                             'msgToScreen',...
                             'name',...
			     'region',...
                             'snippet',...
                             'timeSpanStart',...
                             'timeSpanStop',...                     
                             'timeStamp'};  
    case {'ge_quiver'}
        
        AuthorizedOptions = {'altitude',...
                             'altitudeMode',...
                             'description',...
                             'extrude',...
                             'magnitudeScale',...
                             'msgToScreen',...
                             'lineColor',...
                             'lineWidth',...
                             'name',...
                             'region',...
                             'snippet',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};

    case {'ge_scatter'}
        
        AuthorizedOptions = {'altitudeMode',...
                             'marker',...
                             'markerEdgeColor',...
                             'markerEdgeWidth',...
                             'markerFaceColor',...
                             'markerScale',...
                             'name',...
                             'styleId',...
                             'styleMapId',...
                             'tesselate',...
                             'xUnitShape',...
                             'yUnitShape'};
                         
    case {'ge_surf'}
        
        AuthorizedOptions = {'altitude',...    
                             'altitudeMode',...
                             'altRefLevel',...                     
                             'cLimHigh',...
                             'cLimLow',...
                             'colorMap',...
                             'extrude',...
                             'lineColor',...
                             'lineWidth',...
                             'msgToScreen',...
                             'name',...
                             'nanValue',...                     
                             'polyAlpha',...
                             'region',...
                             'snippet',...
                             'description',...
                             'tessellate',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'vertExagg',...
                             'visibility',...
                             'xResolution',...
                             'yResolution'};

    case {'ge_text'}
        AuthorizedOptions = {'altitudeMode',...
                             'dataFormatStr',...
                             'description',...
                             'msgToScreen',...
                             'pointDataCell',... 
                             'region',...
                             'snippet',...
                             'tableBorderWidth',...
                             'timeSpanStart',...
                             'timeSpanStop',...
                             'timeStamp',...
                             'visibility'};
    case {'ge_windbarb'}
        
        AuthorizedOptions = {'altitudeMode',...
                             'arrowScale',...
                             'msgToScreen',...
                             'name',...
                             'region',...
                             'rLink',...
                             'timeSpanStart',...
                             'timeSpanStop'}; 
      
    case {'ge_writecollada'}
        
        AuthorizedOptions = {'modelStyle',...
                             'faceColor',...
                             'faceAlpha',...
                             'daeFileName'};

    otherwise

        error('non recognized ge_function');

end
