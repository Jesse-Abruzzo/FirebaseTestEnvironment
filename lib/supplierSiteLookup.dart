String supplierSiteLookup(type,name){
  if(type == "Site") {
    switch (name) {
      case 'HV':
        return 'Holtsvile';
      case 'GHZ':
        return 'Guangzhou';
      default:
        return name;
    }
  }else if(type == "Supplier"){
    switch (name) {
      case 'ZBR':
        return 'Zebra';
      case 'JBL':
        return 'Jabil';
      default:
        return name;
    }
  }else{
    return name;
  }
}