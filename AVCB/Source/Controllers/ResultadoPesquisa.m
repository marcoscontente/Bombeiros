//
//  ResultadoPesquisa.m
//  AVCB
//
//  Created by Stefanini on 255//15.
//  Copyright (c) 2015 Prodesp. All rights reserved.
//

#import "ResultadoPesquisa.h"
#import "Util.h"

@interface ResultadoPesquisa ()

@end

@implementation ResultadoPesquisa
{
    NSDictionary *autoData;
    double distance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    autoData = [[Util shared] respostaChamada];
    distance = [[Util shared] distance];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (distance > 100)
    {
        return 7;
    }
    return 6;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Auto de Vistoria do Corpo de Bombeiros do Estado de São Paulo";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UITableViewCell *raioCell = [tableView dequeueReusableCellWithIdentifier:@"RaioCell"];
    
    if (distance > 100)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Situação:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Situacao"];
                break;
            case 1:
                cell.textLabel.text = @"AVCB Nº:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Numero"];
                break;
            case 2:
                cell.textLabel.text = @"Data da Vigência:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Validade"];
                break;
            case 3:
                cell.textLabel.text = @"Razão Social:";
                cell.detailTextLabel.text = [autoData objectForKey:@"RazaoSocial"];
                break;
            case 4:
                cell.textLabel.text = @"Endereço:";
                cell.detailTextLabel.text = [autoData objectForKey:@"DadosLogradouro"];
                break;
            case 5:
                cell.textLabel.text = @"Observações:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Observacoes"];
                break;
            case 6:
                raioCell.textLabel.text = @"Leitura fora do raio de pesquisa";
                break;
                
            default:
                break;
        }
        if (indexPath.row != 6)
        {
            return cell;
        }
        else
        {
            return raioCell
            ;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Situação:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Situacao"];
                break;
            case 1:
                cell.textLabel.text = @"AVCB Nº:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Numero"];
                break;
            case 2:
                cell.textLabel.text = @"Data da Vigência:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Validade"];
                break;
            case 3:
                cell.textLabel.text = @"Razão Social:";
                cell.detailTextLabel.text = [autoData objectForKey:@"RazaoSocial"];
                break;
            case 4:
                cell.textLabel.text = @"Endereço:";
                cell.detailTextLabel.text = [autoData objectForKey:@"DadosLogradouro"];
                break;
            case 5:
                cell.textLabel.text = @"Observações:";
                cell.detailTextLabel.text = [autoData objectForKey:@"Observacoes"];
                break;
                
            default:
                break;
        }
        return cell;
    }
}

@end
