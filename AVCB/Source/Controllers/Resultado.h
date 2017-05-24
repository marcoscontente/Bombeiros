//
//  Resultado.h
//  AVCB
//
//  Created by Vinicius on 9/2/15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"

@interface Resultado : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *autoData;
    double distance;
    BOOL localizacaoHabilitado;
    IBOutlet UITableView *tabela;
}

@end
