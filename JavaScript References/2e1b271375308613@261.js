// https://observablehq.com/@ab2745b75d14b3d0/edav2021fall@261
import define1 from "./01b9f5889f32d3e6@1602.js";

export default function define(runtime, observer) {
  const main = runtime.module();
  const fileAttachments = new Map([["123@6.csv",new URL("./files/b1dc145d73c652034187f4d36b7538a48e489448b64a3ea2073c3ca12b640666ed569d769df353726c765cd2a46e882544ecf9cad40b525d679190dc4683c5b5",import.meta.url)]]);
  main.builtin("FileAttachment", runtime.fileAttachments(name => fileAttachments.get(name)));
  main.variable(observer()).define(["md"], function(md){return(
md`# Sectors of Economy`
)});
  const child1 = runtime.module(define1);
  main.import("TimeChart", child1);
  main.import("TimeAxis", child1);
  main.import("d3", child1);
  main.variable(observer("interval")).define("interval", ["d3"], function(d3){return(
d3.utcDay.every(1)
)});
  main.variable(observer("stop")).define("stop", ["interval"], function(interval){return(
interval()
)});
  main.variable(observer("start")).define("start", ["interval","stop","width"], function(interval,stop,width){return(
interval.offset(stop, -width)
)});
  main.variable(observer("timeOptions")).define("timeOptions", ["d3","width"], function(d3,width)
{
    const interval = d3.utcMinute.every(1440)
    const stop = new Date("2020-04-07T12:45");
    return {
      interval,
      start: interval.offset(stop, -width),
      stop,
      width
  };
}
);
  main.variable(observer("EconomySectors")).define("EconomySectors", ["html","TimeAxis","timeOptions","TimeChart","data2"], function(html,TimeAxis,timeOptions,TimeChart,data2){return(
html`
  ${TimeAxis.defaults(timeOptions)()}
  ${[100, 200, 300, 400, 500, 600].map(status => {
    return TimeChart.defaults(timeOptions)(data2.filter(d => d.status == status), { 
      title: status,
      marginTop: 1,
      scheme: ["blues", "greys", "greens", "purples", "reds", "BuPu"][Math.floor(status / 100) - 1]
    });
  })
}
`
)});
  main.variable(observer("data2")).define("data2", ["FileAttachment"], function(FileAttachment)
{
    // Not authenticated; use demo data
    return FileAttachment("123@6.csv").csv({ typed: true });
  }
);
  return main;
}
