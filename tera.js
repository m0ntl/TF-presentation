// let vnet = createVpc({cidrBlock: '10.0.0.0/16'});
// let subnets = vnet.then(vnet => {
//   let subnets = {
//     'sub1': '10.0.1.0/24',
//     'sub2': '10.0.2.0/24',
//   };
//   return Object.entries(subnets).map(([name, cidr]) => createSubnet({
//     vnetId: vnet.id,
//     cidrBlock: cidr,
//     name: name,
//   }));
// });


// let vnet = createVpc({cidrBlock: '10.0.0.0/16'});
// let subnets = vnet.then(vnet => {
//   let subnets = {
//     'sub1': '10.0.1.0/24',
//     'sub2': '10.0.2.0/24',
//   };
//   return Object.entries(subnets).map([name, cidr] => createSubnet({
//     vnetId: vnet.id,
//     cidrBlock: vnet.then ? cidr : '10.0.5.0/24',
//     availabilityZone: az,
//   }));
// });

