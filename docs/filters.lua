local keywords = {"Float", "Int", "Vector", "Geometry", "Bool", "Matrix", "Rotation", "Material", "Color", "Collection", "String", "Name", "Object", "Input", "Menu"}
local attributes = {"sec_struct", "res_id", "chain_id", "entity_id", "res_name", "atom_name", "atom_id", "occupancy", "bfactor", "atomic_number", "charge", "vdw_radii", "mass", "is_backbone", "is_side_chain", "is_alpha_carbon", "Position", "Index", "Normal", "ID", "b_factor", "is_solvent", "is_nucleic", "is_peptide", "is_hetero", "is_carb", "bond_type"}

local combined = {}
for _, v in ipairs(keywords) do
  table.insert(combined, v)
end
for _, v in ipairs(attributes) do
  table.insert(combined, v)
end

local special_mappings = {
  ["True"] = "True::Bool", 
  ["False"] = "False::Bool",
  ["None"] = "None::Object",
}

function Code(el)
  if special_mappings[el.text] then
    el.text = special_mappings[el.text]
  end
  if el.text:match("^'.*'$") then
    el.text = el.text ..  "::String"
  end  
  for _, keyword in ipairs(keywords) do
    local pattern = "(.+)::" .. keyword
    local name = el.text:match(pattern)
    if name then
      table.insert(el.classes, "custom-" .. keyword:lower())
      el.text = name
      return el
    end
  end
  for _, attribute in ipairs(combined) do
    if el.text == attribute then
      -- el.text = "[".. el.text .. "](attributes.qmd#" .. attribute .. ")"
      table.insert(el.classes, "custom-attribute")
      return el
    end
  end
end
