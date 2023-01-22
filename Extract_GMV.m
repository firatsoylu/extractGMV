% Takes segmented GM images for each participant, extracts GMV values from ROIs 
% and saves them in a csv file
% Based on http://www0.cs.ucl.ac.uk/staff/g.ridgway/vbm/get_totals.m

files = spm_select(inf,'image','Select the image files for each participant');
rois = spm_select(inf,'image','Select all ROI files to extract values for');

imageNumber = (1:length(files(:,1)))';

gmvTable = table(imageNumber);

for k = 1:length(rois(:,1))
    sepROIpath = split(rois(k,:),'/');
    ROIName = split(strtrim(sepROIpath{end}),'.'); % get the ROI Name
    ROIName = ROIName{1};
    gmvValues = extractgmv(files,rois(k,:));
    gmvValues = round(gmvValues,4); % rounds to four decimal points
    tempTable = table(gmvValues);
    gmvTable = [gmvTable tempTable];
    gmvTable.Properties.VariableNames{'gmvValues'} = ROIName;
    fprintf('%s\n',ROIName);
end

writetable(gmvTable,['ROI_extracted_GMV.csv']);


function vals = extractgmv(imgs,roi)
    roi = spm_vol(roi);
    roi = spm_read_vols(roi);
    imgsh = spm_vol(imgs);
    nimgs = length(imgsh);
    vals = zeros(nimgs,1);
    for i = 1:nimgs
        imgvs = abs(det(imgsh(i).mat));
        img = spm_read_vols(imgsh(i));
        img = img .* roi;
        vals(i) = sum(img(:)) * imgvs / 1000;
    end
end


