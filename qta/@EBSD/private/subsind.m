function ind = subsind(ebsd,subs)
% subindexing of EBSD data
%

ind = true(1,numel(ebsd));

for i = 1:length(subs)

  if ischar(subs{i}) || iscellstr(subs{i})

    min = ensurecell(subs{i});

    minerals = get(ebsd,'minerals');
    phases = false(1,length(minerals));
    for j =1:length(min)
      phases = phases | strncmpi(minerals,min{j},length(min{j}));
    end
    ind = ind & phases(ebsd.phase(:).');

  elseif isa(subs{i},'grain')

    ind = ind & ismember(ebsd.options.grain_id,get(subs{i},'id'))';

  elseif isa(subs{i},'logical')

    ind = ind & reshape(subs{i},size(ind));

  elseif isnumeric(subs{i})

    iind = false(size(ind));
    iind(subs{i}) = true;
    ind = ind & iind;
    
  elseif isa(subs{i},'polygon')
    
    ind = ind & inpolygon(ebsd,subs{i})';
    
  end
end